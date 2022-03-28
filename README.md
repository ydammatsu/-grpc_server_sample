# grpc_server_sample
Ruby で書いた勉強用の gRPC Server

## 起動コマンド
```
bundle exec ruby bin/server.rb
```

## ディレクトリ構成
```
.
├── Gemfile
├── Gemfile.lock
├── README.md
├── bin
│   └── server.rb # 実際に gRPC server を起動するファイル
├── lib
│   ├── file_storage_server.rb # ここにリクエストを処理してレスポンスを生成する部分を書く
│   └── s3.rb # S3と接続する部分
└── pb # .proto から自動生成したコードの置き場
    ├── sample_pb.rb
    └── sample_services_pb.rb
```
## .proto からコードを自動生成するコマンド
※ `gem "grpc-tools"` が必要

```
bundle exec grpc_tools_ruby_protoc -I {protoファイルがあるディレクトリのパス} --ruby_out={生成コードを出力するパス} --grpc_out={生成コードを出力するパス} {protoファイルのパス}
```

このコードで言うと..

```
bundle exec grpc_tools_ruby_protoc -I ../proto --ruby_out=pb --grpc_out=pb ../proto/sample.proto
```

## 生成されたコードを require することで使えるようになるもの
- リクエストを送るためのスタブを生成するクラス
- サーバーに渡す用のクラス
- リクエスト・レスポンスに使うメッセージを生成する用のクラス
