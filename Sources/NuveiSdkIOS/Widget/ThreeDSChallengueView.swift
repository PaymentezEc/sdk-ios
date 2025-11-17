//
//  SwiftUIView.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 16/11/25.
//

import SwiftUI
import WebKit

struct ThreeDSChallengeView: UIViewRepresentable {
    let htmlContent: String
       let onFinish: () -> Void

       class Coordinator: NSObject, WKNavigationDelegate {
           var parent: ThreeDSChallengeView

           init(parent: ThreeDSChallengeView) {
               self.parent = parent
           }
       }

       func makeCoordinator() -> Coordinator {
           Coordinator(parent: self)
       }

       func makeUIView(context: Context) -> WKWebView {
           let webview = WKWebView()
           webview.navigationDelegate = context.coordinator

           webview.loadHTMLString(htmlContent, baseURL: nil)
           return webview
       }

       func updateUIView(_ uiView: WKWebView, context: Context) {}
}

#Preview {
    ThreeDSChallengeView(htmlContent: "<!DOCTYPE html SYSTEM 'about:legacy-compat'><html class='no-js' lang='en'xmlns='http://www.w3.org/1999/xhtml'><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'/><meta charset='utf-8'/></head><body OnLoad='OnLoadEvent();'><form action='https://ccapi-stg.paymentez.com/v2/3ds/mockchallenge' method='POST' id='threeD' name='threeD'>message_id: <input type='area' id='message_id' name='message_id' value='AU-106430' />;creq: <input type='area' id='creq'name='creq' value='ewogICAiYWNzVHJhbnNJRCIgOiAiMjZjZGI3ZjAtOTE0My00M2I0LTlhM2YtYWUwZWE1MzUyMzhjIiwKICA' />; \"term_url: <input type='area' id='term_url' name='term_url' value='https://lantechco.ec/img/callback3DS.php' />;\n <input type='submit' value='proceed to issuer'></form><script language='Javascript'>document.getElementById('threeD').submit(); </script></body></body></html>", onFinish: {})
}
