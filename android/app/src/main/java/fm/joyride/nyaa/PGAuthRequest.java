package fm.joyride.nyaa;

import com.google.gson.annotations.SerializedName;

public class PGAuthRequest {

    @SerializedName("code")
    public String code;
    @SerializedName("playerId")
    public String playerId;

    public PGAuthRequest(String code, String playerId) {
        this.code = code;
        this.playerId = playerId;
    }


}