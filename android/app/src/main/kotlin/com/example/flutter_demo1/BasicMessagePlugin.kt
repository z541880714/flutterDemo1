package com.example.flutter_demo1

import io.flutter.embedding.android.FlutterView
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.StringCodec

/**
 *
 * author: Lionel
 * date: 2022-01-03 11:19
 */
class BasicMessagePlugin : BasicMessageChannel.MessageHandler<String> {

    private lateinit var messageChannel: BasicMessageChannel<String>


    override fun onMessage(message: String?, reply: BasicMessageChannel.Reply<String>) {

    }


}