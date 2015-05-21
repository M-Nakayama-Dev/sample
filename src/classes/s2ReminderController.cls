public class s2ReminderController {

    // 定数
    private static final string FromMail = 'Recruit Login Reminder';
    private static final String SUBJECT = 'パスワードの再登録を行って下さい';

    //ユーザID
    private String UserId;
    public void setUserId(String s){
        this.UserId = s;
    }
    public String getUserId(){
        return this.UserId;
    }

    //パスワード(ビューステートの一部として送信されないようにする)
    private transient String NewPassword;
    public void setNewPassword(String s){
        this.NewPassword = s;
    }
    public String getNewPassword(){
        return this.NewPassword;
    }

    private transient String ConPassword;
    public void setConPassword(String s){
        this.ConPassword = s;
    }
    public String getConPassword(){
        return this.ConPassword;
    }

    //MD5ハッシュ値
    public string getmd5hash(String str){
        String md5str =  EncodingUtil.convertToHex(Crypto.generateDigest('md5', Blob.valueOf(str)));
        return md5str;
    }

    //キャンセルボタン
    public PageReference doCancel() {
        return Page.s2Login;
    }

    //メール送信
    public PageReference doMail() {

        try{

            //警告フラグ
            Boolean ErrorFlg = false;

            //必須チェック
            if (String.isEmpty(UserId)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    'ユーザIDは必須入力です', ''));
                ErrorFlg = true;
            }
            if (ErrorFlg) {
                return null;
            }

            //担当者オブジェクトの取得
            List<Account> lstAct =
                [select id, name, EmployeeNo__c, EMail__c
                from Account where EmployeeNo__c = :UserId];
            Account Act = null;
            if (lstAct.size() == 0) {
                //レコード存在チェック
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    'ユーザID「' + UserId + '」は存在しないIDです', ''));
                return null;
            } else {
                Act = lstAct[0];
            }

            //仮パスワードの登録
            GenericHistory__c HRem = new GenericHistory__c();
            Blob b = Crypto.GenerateAESKey(128);    //仮パスワード乱数設定
            String key = EncodingUtil.ConvertTohex(b);
            HRem.Section__c = 'リマインダー';
            HRem.ProvisionalPassword__c = key;    //参照設定している担当者オブジェクトのID
            HRem.URL__c = 'https://' + ApexPages.currentPage().getHeaders().get('Host') +  Page.s2ReminderConfirm.geturl() + '?key=' + key;
            HRem.Enabled__c = true;    //有効
            HRem.Account__c = Act.id;
            HRem.EnabledDate__c = datetime.now().addDays(1); //TODO 期限をきめないといけない、とりあえず１日
            List<GenericHistory__c> lstHRem = new List<GenericHistory__c>();
            lstHRem.add(HRem);
            insert lstHRem;

            //メールアドレス設定
            String[] toAddresses = new string[0];
            toAddresses.add(Act.EMail__c);
            //メール送信
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('パスワード再発行');
            mail.setPlainTextBody(
                '以下のアドレスにアクセスしてパスワードの再登録を行ってください\r\n' +
                '\r\n' +
                '[URL]' + '\r\n' +
                HRem.URL__c + '\r\n' +
                '\r\n' +
                '[URLの有効期限]' + '\r\n' +
                HRem.EnabledDate__c.format('yyyy/MM/dd HH:mm:ss', 'JST') + '　まで\r\n' +
                '\r\n' +
                '………………………………………………………………' + '\r\n' +
                '※URLの有効期限を過ぎますと、URLが無効となり、' + '\r\n' +
                '　アクセスすることができなくなります。' + '\r\n' +
                '………………………………………………………………' + '\r\n'
            );
            mail.setToAddresses(toAddresses);
            mail.setSaveAsActivity(true);
            mail.setSenderDisplayName(FromMail);

            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, User.Mail__c, ''));
            // 送信
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { mail });

            //メール送信完了ページ遷移
            PageReference pageRef = page.s2ReminderSend;
            return pageRef;
        }


        catch (Exception e) {
            // Handle this exception here
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    e.getMessage(), ''));
        }


        return null;

    }



}