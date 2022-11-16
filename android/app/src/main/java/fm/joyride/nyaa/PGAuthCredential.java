package fm.joyride.nyaa;

import com.google.gson.annotations.SerializedName;

public class PGAuthCredential {


    @SerializedName("refresh_token")
    public String refresh_token;
    @SerializedName("expiry_date")
    public String expiry_date;
    @SerializedName("access_token")
    public String access_token;
    @SerializedName("token_type")
    public String token_type;
    @SerializedName("id_token")
    public String id_token;
    @SerializedName("scope")
    public String scope;

    public PGAuthCredential(String refresh_token, String expiry_date, String access_token, String token_type, String id_token, String scope) {
        this.refresh_token = refresh_token;
        this.expiry_date = expiry_date;
        this.access_token = access_token;
        this.token_type = token_type;
        this.id_token = id_token;
        this.scope = scope;
    }


}