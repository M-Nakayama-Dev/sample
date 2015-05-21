global class PasswordChangeLimit implements Schedulable {
    global void execute(SchedulableContext sc) {
        // スケジュール実行させたい処理
        
        
        try{

            //担当者
            List<User__c> lstUser =  [SELECT id, Number__c, Name, Mail__c From User__c];
            if (lstUser.size() == 0) {
                //レコード存在チェック
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    'ユーザ情報が存在しませんでした', ''));
                return;
            }
            
            for (User__c c: lstUser) {
            
                password__c Pass = [SELECT id, Number__c, PasswordLimit__c 
                                         From password__c
                                        WHERE PasswordLimit__c <= :date.today() ];
                
                if (Pass == null) {
                system.debug('該当あり');
                
                } else {
                system.debug('該当なし');
                
                }
            
            }



/*
            //担当者オブジェクトの取得
            List<User__c> lstUser =
                [select id, name, Number__c, Mail__c
                from User__c where Number__c = :UserId];
            User__c User = null;
            if (lstUser.size() == 0) {
                //レコード存在チェック
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    'ユーザID「' + UserId + '」は存在しないIDです', ''));
                return null;
            } else {
                User = lstUser[0];
            }

            //仮パスワードの登録
            Reminder__c rem = new Reminder__c();
            Blob b = Crypto.GenerateAESKey(128);    //仮パスワード乱数設定
            String key = EncodingUtil.ConvertTohex(b);
            rem.ProvisionalPassword__c = key;    //参照設定している担当者オブジェクトのID
            rem.URL__c = 'https://' + ApexPages.currentPage().getHeaders().get('Host') +  Page.ReminderConfirm.geturl() + '?key=' + key;
            rem.Status__c = '送信済';    //ステータス
            rem.User__c = User.Id;
            rem.ChangeLimit__c = datetime.now().addDays(1); //TODO 期限をきめないといけない、とりあえず１日
            List<Reminder__c> lstrem = new List<Reminder__c>();
            lstrem.add(rem);
            insert lstrem;

            //メールアドレス設定
            String[] toAddresses = new string[0];
            toAddresses.add(User.Mail__c);
            //メール送信
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('パスワード再発行');
            mail.setPlainTextBody(
                '以下のアドレスにアクセスしてパスワードの再登録を行ってください\r\n' +
                '\r\n' +
                '[URL]' + '\r\n' +
                rem.URL__c + '\r\n' +
                '\r\n' +
                '[URLの有効期限]' + '\r\n' +
                rem.ChangeLimit__c.format('yyyy/MM/dd HH:mm:ss', 'JST') + '　まで\r\n' +
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
*/

            return;
        }


        catch (Exception e) {
            // Handle this exception here
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    e.getMessage(), ''));
        }

        
        
        
    }
}