package fm.joyride.nyaa;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.getcapacitor.BridgeActivity;
import com.getcapacitor.PluginCall;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        registerPlugin(FriendsPlugin.class);
        super.onCreate(savedInstanceState);
    }
//    @Override
//    public void onActivityResult(int requestCode, int result, Intent data) {
//        if (requestCode == FriendsPlugin.SHOW_SHARING_FRIENDS_CONSENT) {
//            if (result == Activity.RESULT_OK) {
//                // We got consent from the user to access their friends. Retry loading the friends
//                // callLoadFriends();
//                PluginCall call = bridge.getSavedCall("ugggh");
//                Log.i("UGH", "ugh");
//            } else {
//                // User did not grant consent.
//            }
//        }
//        else {
//            super.onActivityResult(requestCode, result, data);
//        }
//    }
}
