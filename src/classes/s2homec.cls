/**
 * ポータル画面コンポーネントコントローラ
 * 実質のコントローラークラス
 *
 */
public class s2homec extends BaseComponentController {

    public Boolean isSFDCUser {
        get {
            return dto.isSFDCUser();
        }
        set;
    }

}