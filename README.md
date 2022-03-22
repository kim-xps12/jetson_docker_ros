# jetson_docker_ros

## はじめに
Jetson Xavier NXでROSを使うのに，dockerコンテナを立てて中で一般ユーザを設定し，virtualenv的な使い方をしたかったのですが良い設定が見つからなかったので作りました．
cudaにアクセスできてrvizをjetson単体で実行でき，ROSをネイティブインストールしたのと同じような感覚で使えることを目指しました．


## 想定環境
- ハードウェア : Jetson Xavier NX
- ホスト側OS : Jetpack 4.5.0 --- Jetpack 4.6以降だとnvidia-runtimeを使ってコンテナを立てる際にPermmission Deniedが出る[[1]](https://forums.developer.nvidia.com/t/docker-error-response-from-daemon-failed-to-create-shim-oci-runtime-create-failed-container-linux-go-starting-container-process-caused-error/197663/3)そうなので，4.5系を使っています．
（後で確認したらSDに焼いたイメージは4.5.0でしたが勝手に4.5.2まで上がっていました，ぱっと見は動作に問題なさそうです．）
- コンテナ側OS : Jetpack 4.5.0
- ROS Distribution : Melodic
- CUDA使用 : あり
- GUI使用 : あり
- コンテナ内ユーザ種別 : 一般ユーザ
- コンテナ内ユーザ名 : docker
- コンテナ内ユーザPW : docker （ユーザ名/PWは適宜変更してください）
- Dockerバージョン : 20.10.13 build 1224086
- docker-composeバージョン : 1.29.2 build unknown（aptで入れると1.19が入りますが，1.21以降でないとruntimeのタグが使えないためエラーで落ちるので注意．僕はpip3でインストールしました）

## 使い方
1. このリポジトリをcloneする．
   
   ```
   git clone https://github.com/kim-xps12/jetson_docker_ros.git
   ```

2. 公式の手順でDockerをインストール[[2]](https://docs.docker.com/engine/install/ubuntu/) する．
3. pip3でdocker-composeをインストール[[3]](https://matsuand.github.io/docs.docker.jp.onthefly/compose/install/)する．
4. お使いのユーザをdockerグループに追加し，sudo無しでdockerコマンドが実行できるように[[4]](https://qiita.com/ITF_katoyu/items/1bdaaad9f64af86bbfb7)する．
5. launch_compose.shに実行権限を付与する．

   ```
   cd jetson_docker_ros
   chmod +x
   ```
   
7. launch_compose.shを実行する．エラーが起きなければattachまで自動で行われる．
   ```
   ./launch_compose.sh
   ```

9. コンテナ内で`glmark2`や`rviz`正常に動作すればOK！

   glmark2の場合
   ```
   glmark2
   ```
   
   rvizの場合
   
   tmuxでペインを2個以上作り，片方で`roscore`，もう片方で`rviz`

1. お好みでパッケージ名のtab補完[[5]](https://penguin-coffeebreak.com/archives/242)も使えるようにしておくと便利かもしれません．

## 参考
[1] [https://forums.developer.nvidia.com/t/docker-error-response-from-daemon-failed-to-create-shim-oci-runtime-create-failed-container-linux-go-starting-container-process-caused-error/197663/3](https://forums.developer.nvidia.com/t/docker-error-response-from-daemon-failed-to-create-shim-oci-runtime-create-failed-container-linux-go-starting-container-process-caused-error/197663/3)

[2] [https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)

[3] [https://matsuand.github.io/docs.docker.jp.onthefly/compose/install/](https://matsuand.github.io/docs.docker.jp.onthefly/compose/install/)

[4] [https://qiita.com/ITF_katoyu/items/1bdaaad9f64af86bbfb7](https://qiita.com/ITF_katoyu/items/1bdaaad9f64af86bbfb7)

[5] [https://penguin-coffeebreak.com/archives/242](https://penguin-coffeebreak.com/archives/242)
