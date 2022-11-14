package fm.joyride.nyaa;

import com.google.gson.annotations.SerializedName;

public class PGAuthResult {

    @SerializedName("result")
    public String result;

    public PGAuthResult(String result) {
        this.result = result;
    }


}