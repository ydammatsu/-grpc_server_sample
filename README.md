# proto からコードを生成するコマンド
bundle exec grpc_tools_ruby_protoc -I {protoファイルがあるディレクトリのパス} --ruby_out={生成コードを出力するパス} --grpc_out={生成コードを出力するパス} {protoファイルのパス}

このコードで言うと..

bundle exec grpc_tools_ruby_protoc -I ../proto --ruby_out=pb --grpc_out=pb ../proto/sample.proto