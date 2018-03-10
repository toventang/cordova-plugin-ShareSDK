package com.simpleel.cordova.sharesdk;

import android.util.Log;
import android.content.Context;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.apache.cordova.PluginResult;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import cn.sharesdk.onekeyshare.OnekeyShare;

public class ShareSDK extends CordovaPlugin {

  public static final String KEY_ARG_TITLE = "title";
  public static final String KEY_ARG_TITLEURL = "titleUrl";
  public static final String KEY_ARG_TEXT = "text";
  public static final String KEY_ARG_IMAGE = "image";
  public static final String KEY_ARG_URL = "url";
  public static final String KEY_ARG_COMMENT = "comment";
  public static final String KEY_ARG_SITE = "site";
  public static final String KEY_ARG_SITEURL = "siteUrl";

  private static final String TAG = "simpleel.ShareSDK";
  private Context mContext;

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    if (action.equals("share")) {
      return this.share(args, callbackContext);
    }
    return false;
  }

  private boolean share(JSONArray message, CallbackContext callbackContext) {
    if (message != null && message.length() > 0) {
      OnekeyShare oks = new OnekeyShare();
      //关闭sso授权
      oks.disableSSOWhenAuthorize();

      final JSONObject params;
      try {
        params = message.getJSONObject(0);
        // 分享时Notification的图标和文字  2.5.9以后的版本不调用此方法
        // oks.setNotification(R.drawable.ic_launcher, getString(R.string.app_name));
        // title标题，印象笔记、邮箱、信息、微信、人人网和QQ空间使用
        if (params.has(KEY_ARG_TITLE))
          oks.setTitle(params.getString(KEY_ARG_TITLE));
        // titleUrl是标题的网络链接，仅在人人网和QQ空间使用
        if (params.has(KEY_ARG_TITLEURL))
          oks.setTitleUrl(params.getString(KEY_ARG_TITLEURL));
        // text是分享文本，所有平台都需要这个字段
        if (params.has(KEY_ARG_TEXT))
          oks.setText(params.getString(KEY_ARG_TEXT));
        // imagePath是图片的本地路径，Linked-In以外的平台都支持此参数
        if (params.has(KEY_ARG_IMAGE))
          oks.setImagePath(params.getString(KEY_ARG_IMAGE));//确保SDcard下面存在此张图片
        // url仅在微信（包括好友和朋友圈）中使用
        if (params.has(KEY_ARG_URL))
          oks.setUrl(params.getString(KEY_ARG_URL));
        // comment是我对这条分享的评论，仅在人人网和QQ空间使用
        if (params.has(KEY_ARG_COMMENT))
          oks.setComment(params.getString(KEY_ARG_COMMENT));
        // site是分享此内容的网站名称，仅在QQ空间使用
        if (params.has(KEY_ARG_SITE))
          oks.setSite(params.getString(KEY_ARG_SITE));
        // siteUrl是分享此内容的网站地址，仅在QQ空间使用
        if (params.has(KEY_ARG_SITEURL))
          oks.setSiteUrl(params.getString(KEY_ARG_SITEURL));

        // 启动分享GUI
        mContext = cordova.getActivity().getApplicationContext();
        oks.show(mContext);
      } catch (JSONException e) {
        Log.i(TAG+".share", e.toString());
        callbackContext.error("Invalid params");
        return false;
        //callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
      }
      callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
      //callbackContext.success(message);
      return true;
    } else {
      callbackContext.error("Expected one non-empty string argument.");
      return false;
    }
  }

}
