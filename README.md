# grpc_server_sample
Ruby で書いた勉強用の gRPC Server

## ディレクトリ構成
```
.
├── Gemfile
├── Gemfile.lock
├── README.md
├── bin
│   └── server.rb # 実際に gRPC server を起動するファイル
├── lib
│   ├── file_storage_server.rb # gRPC handler に渡すクラス
│   └── s3.rb # S3と接続する部分
└── pb # Proto から自動生成したコードの置き場
    ├── sample_pb.rb
    └── sample_services_pb.rb
```
# .proto からコードを自動生成するコマンド
※ `gem "grpc-tools"` が必要

```
bundle exec grpc_tools_ruby_protoc -I {protoファイルがあるディレクトリのパス} --ruby_out={生成コードを出力するパス} --grpc_out={生成コードを出力するパス} {protoファイルのパス}
```

このコードで言うと..

```
bundle exec grpc_tools_ruby_protoc -I ../proto --ruby_out=pb --grpc_out=pb ../proto/sample.proto
```
