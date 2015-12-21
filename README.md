# CINRA Project Template

## Init

hosts:
```shell
192.168.33.5    cinra.dev
```

```shell
# vagrant up
# vagrant provision
```

## Dependencies

- Virtual Box
- Vagrant
- Chef
- Chef Solo

## Usage



## Issues

### Guest Additions対策

Mac OSXで、ゲストマシン（Linux）のGuest Additionsが合わず、共有フォルダが同期できない問題。
下記操作で解決できる

1. Guest Additionのバージョンを合わせなくてはならないのでVagrantのプラグイン「vagrant-vbguest」が入っていなかったらインストールしておく。 `$ vagrant plugin install vagrant-vbguest`
1. ゲストマシンにログイン `$ vagrant ssh`
1. rootとしてログインしておく `$ sudo su`。
1. kernel-develのインストール：ゲストマシンで、`/etc/yum.conf`を編集。最終行にある`exclude=kernel*`をコメントアウト
1. `yum install -y kernel-devel`が動くようになるので、インストール
1. KERN_DIRを設定：`$ export KERN_DIR=/usr/src/kernels/2.6.32-504.3.3.el6.x86_64`（最後はカーネルのバージョン。`$ export KERN_DIR=/usr/src/kernels/`まで入力して、TABで表示される）
1. kernelのアップデート：`$ yum -y update kernel`
1. kernel周りのインストール：`$ yum -y install kernel-devel kernel-headers dkms gcc gcc-c++`
1. ゲストマシンからログアウト。 `$ exit`（`root`権限に変更していた場合、二回必要です）
1. ゲストマシンを再起動 `# vagrant reload`