# Rspec
- テストコードは「DRYさ」よりも「読みやすさ」！
- 中身のないitを書いて、テストはあとで書こう
- expextは、期待する結果を変数にせず、なべくベタ書きで。

## 「実行コマンド」に関するTips
実行コマンド
```
rspec spec/test_spec.rb
rspec spec/test_spec.rb --color --format d # 加えて色付けたい時
rspec spec/test_spec.rb --color --format d --order defined # 加えて順番変えたくない時
```

テスト構造を把握するコマンド
```
rspec spec/test_spec.rb --dry-run --order defined
```

## 「設定」に関するTips
RSpecの設定は、spec_helper.rbやrails_helper.rbの中で行われ、
テストの上位10個の遅いテストを表示する設定が
```
config.profile_examples = 10
```
でされている。

```
config.profile_examples = false
```
にすれば、出力されなくなるが、業務で出力して確かめるのも大事かも？

## 「Rspecのメソッド」に関するTips
#### テストの構造を決める編
- describe 〜の検証
- context 〜の場合
  - なるべく並列の条件を並べる。並列にできない条件が出てきた際に、describeを使って名前空間を作る。
  - 分岐がなければ、1つ。分岐が1つあれば2つのイメージで作成する
- it 〜こと（このブロックで定義されたテスト内容をexampleと呼んだりする）  
  - 中身の無い it。doのブロックなしにすると、Pendingになる。
  - example と specifyは、it のエイリアス。自然な英文を作るためなので、日本語なら使わなくて良さそう。
  - let(:foo) { ... } のように書くと、 { ... } の中の値が foo として参照できるが、ハッシュを定義すると、let(:params) { { name: 'たろう' } }　みたいになるからわかり辛い

#### 定義しちゃう編
- before そのブロックで使いたい定義
- let 遅延評価の特徴があることから、expectで出てくる定義を上に上に読んでいける
- let!は、事前に実行されるため、レコードがデータベースに保存されていないからエラーが起きるみたいなことが発生しない
- subject テストするオブジェクトやメソッドが決まっているとき、あらかじめ定義する。is_expectedを使うと、subjectが実行されたとして、テスト実施される
  - 業務では、subjectをメソッドや変数のように使い回さず、is_expectedを使うようにする

#### あんま使わないけど覚えてはおこう編
- shared_examples、it_behaves_likeは、itでテストする内容を再利用できるもの。**定義元だどる必要があるので、業務では禁止**
- shared_context と include_contextは、context内のbeforeやletで定義を再利用して使える。shared_contextで定義して、include_contextで使う。include_contextは、context内のbeforeやletで定義を再利用して使える。shared_contextで定義して、include_contextの""の内容が一緒だと呼び出される。**定義元だどる必要があるので、業務では禁止**
- pending（保留） は、実行を中断するのではなく、そのまま実行を続けることができる　← あんま使わん
- skipは、それ以降実行を止めることができる　　← あんま使わん
- xitは、ブロック丸ごと実行しない
- xdescribe / xcontextは、グループ全体をまとめてskipさせる
- described_class 今テストしているクラスをインスタンス化させるときに使うメソッド。**業務では読みにくくなるので禁止**

#### マッチャ編
マッチャ（matcher）は「期待値と実際の値を比較して、一致した（もしくは一致しなかった）という結果を返すオブジェクト。  
eq や includeをマッチャという。toはマッチャではない。  
<br>
以下マッチャ一覧
- eq はイコール
- be は、等号・不等号と組み合わせて、値の大小を検証するときによく使われるマッチャ
- be_xxx (predicateマッチャ=述語的マッチャ)という。
- be_empty は、空かどうか
- be_valid は、バリデーションにかかるかどうか
- be_truthy と be_falsey は、true / falseを返すかのテストで使う
```
expect(user.save).to be_falsey　# saveできることを検証
expect(user.save).to be_truthy # saveできないことを検証
```
  
「trueっぽい値」または「falseっぽい値」なので、どちらもパスする
```
expect(1).to be_truthy # 判定した結果がtrueだから
expect(nil).to be_falsey
```
  
どちらも失敗する
```
expect(1).to be true # 1 = trueではないから失敗
expect(nil).to be false
```
  
be の代わりに eq を使った場合も同様に失敗する
```
expect(1).to eq true
expect(nil).to eq false
```
  
- change は内容が変更されることを意味する
  - from/to で何から何に変化したのかかく
  - by で変化した数をかく
- include は含まれているか。
```
expect(x).to include 1, 3
```
  
- raise_error は、エラーが正しく起こるかどうかを確認するもの。異常系のテストとかで使えそう。
- be_within は、be_within(1.0).of(25.0)で25から±1を許容しているかテストするもの

#### モック編
    # エラー処理（異常系）こそテストが大事
    # エラーをわざと発生させること自体が難しい場合、エラー処理をテストしないままリリース
    # → エラー処理に不具合があると、顧客影響へ。
    # エラーを出すことが難しい場合 → モックを使う

    # モックが使いやすい設計にしましょう

    # モックは、テストしてもいいようにプログラムを変更するもの
    # ex.テスト中に呼び出すメソッドやインスタンスによって、SNSに投稿するのような実行してほしくない場合に、代わりに実行したことにするもの

    # allowメソッド は、allow(モックオブジェクト).to receive(メソッド名)
    # "allow A to receive B" で、「A が B を受け取ることを許可する」

    # expectメソッド は、expect(twitter_client_mock).to receive(:update)
    # expect を使うと「そのメソッドが呼び出されないとテスト失敗

    # .and_raise は、updateのような受け取る予定のメソッドが呼び出された時に、わざとエラーを発生させるメソッド
    # allow(twitter_client_mock).to receive(:update).and_raise('エラーが発生しました')

    # .once を付けると「1回だけ呼び出すこと」を検証できる。呼び出された数がテストされる
    # 2回以上呼び出されるとエラーに
    # expect(weather_bot).to receive(:notify).once
    # twice　で2回
    # exactly(n).times でn回呼び出す

    # .with は、 with(検証したい引数の内容) の形で引数の中身を検証、できる
    # expect(twitter_client_mock).to receive(:update).with('今日は晴れです')
    # 引数は '今日は晴れです' かつ、呼び出される回数は1回だけであることを検証
    # expect(twitter_client_mock).to receive(:update).with('今日は晴れです').once
    # 2つの引数を検証することも可能
    # expect(user).to receive(:save_profile).with('Alice', 'alice@example.com')
    # とりあえず何かしら渡ってきてほしいことを確認
    # expect(user).to receive(:save_profile).with('Alice', anything)
    # ハッシュで確認することも可能（特定のkeyとvalueだけに着目する場合は hash_including を使う）
    # expect(user).to receive(:save_profile).with(name: 'Alice', email: 'alice@example.com')

    # allow_any_instance_of メソッドを使うと、対象クラスの全インスタンスに対して目的のメソッドをモック化（基本使わない方がいい→でも業務では使われている）（246件ヒット）
    # allow_any_instance_of(WeatherBot).to receive(:twitter_client).and_return(twitter_client_mock)
    # 1.理解しづらいテストコードになる
    # 2.必要ということは設計自体がイケてない可能性がある
    # 3.allow_any_instance_ofの中身は複雑な実装になっていて不具合起きる

    # receive_message_chain メソッドを使うと、2つの処理をモック化できる（業務では124件ヒット）
    # 例えば、「検索実行」と「本文の返却」という2つの処理をモック化すると、
    # allow(weather_bot).to receive_message_chain('twitter_client.search.first.text').and_return('西脇市の天気は曇りです')
    # 「インスタンスを作る」と「flagを作成する」の処理をモック化すると、
    # allow(FeatureFlags).to receive_message_chain(:create_instance, :get_flag).with(引数).and_return(Flag.new(引数, true, { "company_ids" => [company.id] }))
    # allow(twitter_client_mock).to receive(:search).and_return([status_mock]) のように、モックがモックを返す時に、使える
    # receive_message_chain を使っているということは、「デメテルの法則」（結合度が高い）に違反したクラス設計になっていることに注意

    # as_null_object というメソッドを付けると、どんなメソッドが呼ばれても許容する（業務では使われてなかった）
    # twitter_client_mock = double('Twitter client').as_null_object
    # allow(twitter_client_mock).to receive(:update) は不要
