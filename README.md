# Rspec
## 方針
- テストコードは「DRYさ」よりも「読みやすさ」
- 中身のないitを書いて、テストはあとで書こう
- expextは、期待する結果を変数にせず、なべくベタ書きで
- エラー処理（異常系）こそテストが大事
  - エラーをわざと発生させること自体が難しい場合、エラー処理をテストしないままリリースしまい、エラー処理に不具合があったときにインシデントに、、、
  - **エラーを出すことが難しい場合 → モックを使う**
- モックが使いやすい設計にしましょう

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
### テストの構造編
- describe 〜の検証
- context 〜の場合
  - なるべく並列の条件を並べる。並列にできない条件が出てきた際に、describeを使って名前空間を作る。
  - 分岐がなければ、1つ。分岐が1つあれば2つのイメージで作成する
- it 〜こと（このブロックで定義されたテスト内容をexampleと呼んだりする）  
  - 中身の無い it。doのブロックなしにすると、Pendingになる。
  - example と specifyは、it のエイリアス。自然な英文を作るためなので、日本語なら使わなくて良さそう。
  - let(:foo) { ... } のように書くと、 { ... } の中の値が foo として参照できるが、ハッシュを定義すると、let(:params) { { name: 'たろう' } }　みたいになるからわかり辛い

### 定義編
- before そのブロックで使いたい定義
- let 遅延評価の特徴があることから、expectで出てくる定義を上に上に読んでいける
- let!は、事前に実行されるため、レコードがデータベースに保存されていないからエラーが起きるみたいなことが発生しない
- subject テストするオブジェクトやメソッドが決まっているとき、あらかじめ定義する。is_expectedを使うと、subjectが実行されたとして、テスト実施される
  - 業務では、subjectをメソッドや変数のように使い回さず、is_expectedを使うようにする

### あんま使わない編
- shared_examples、it_behaves_likeは、itでテストする内容を再利用できるもの。**定義元だどる必要があるので、業務では禁止**
- shared_context と include_contextは、context内のbeforeやletで定義を再利用して使える。shared_contextで定義して、include_contextで使う。include_contextは、context内のbeforeやletで定義を再利用して使える。shared_contextで定義して、include_contextの""の内容が一緒だと呼び出される。**定義元だどる必要があるので、業務では禁止**
- pending（保留） は、実行を中断するのではなく、そのまま実行を続けることができる　← あんま使わん
- skipは、それ以降実行を止めることができる　　← あんま使わん
- xitは、ブロック丸ごと実行しない
- xdescribe / xcontextは、グループ全体をまとめてskipさせる
- described_class 今テストしているクラスをインスタンス化させるときに使うメソッド。**業務では読みにくくなるので禁止**

### マッチャ編
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

### モック編
モックは、テストしてもいいようにプログラムを変更するもの
- ex.テスト中に呼び出すメソッドやインスタンスによって、SNSに投稿するのような実行してほしくない場合に、代わりに実行されるもの

#### allow 許可する（使わなくてもいい）
allow(モックオブジェクト).to receive(メソッド名)
allow A to receive B" で、「A が B を受け取ることを許可する」

#### expect 必ず使うこと
expect 使うとそのメソッドが呼び出されないとテスト失敗になる
```
expect(twitter_client_mock).to receive(:update)
```

#### .and_raise エラーが起きたとする
.and_raise は、updateのような受け取る予定のメソッドが呼び出された時に、わざとエラーを発生させるメソッド。
```
allow(twitter_client_mock).to receive(:update).and_raise('エラーが発生しました')
```

#### .once / .twice / exactly(n).times 呼び出された数の検証
.once を付けると「1回だけ呼び出すこと」を検証できる。呼び出された数がテストされる
```
expect(weather_bot).to receive(:notify).once # 2回以上呼び出されるとエラーに
expect(weather_bot).to receive(:notify).twice # 2回までエラーにならない
expect(weather_bot).to receive(:notify).exactly(n).times # n回までにエラーにならない
```

#### .with 引数の中身を検証
.with は、 with(検証したい引数の内容) の形で引数の中身を検証できる
```
expect(twitter_client_mock).to receive(:update).with('今日は晴れです')
expect(twitter_client_mock).to receive(:update).with('今日は晴れです').once # 引数は '今日は晴れです' かつ、呼び出される回数は1回だけであることを検証

expect(user).to receive(:save_profile).with('Alice', 'alice@example.com') # 2つの引数が正しいことを検証することも可能
expect(user).to receive(:save_profile).with('Alice', anything) # とりあえず何かしら渡ってきてほしいことを検証（第二引数がない場合はエラー）

expect(user).to receive(:save_profile).with(name: 'Alice', email: 'alice@example.com') # ハッシュも検証可能
expect(user).to receive(:save_profile).with(hash_including(name: 'Alice')) # 特定のkeyとvalueだけに着目して検証
```
    
#### allow_any_instance_of 全てのインスタンスをモック化（非推奨）
allow_any_instance_of メソッドを使うと、対象クラスの全インスタンスに対して目的のメソッドをモック化（基本使わない方がいい。しかし現状246件業務では使われている）
```
allow_any_instance_of(WeatherBot).to receive(:twitter_client).and_return(twitter_client_mock)
```
使わない方がいい理由
1. 理解しづらいテストコードになる
2. 必要ということは設計自体がイケてない可能性がある
3. allow_any_instance_ofの中身は複雑な実装になっていて不具合起きる

#### as_null_object 作成したモックに対してなんのメソッドでもallowしたことになる
as_null_object というメソッドを付けると、作成したモックにどんなメソッドが呼んでも許容する（業務では使われてなかった）
```
twitter_client_mock = double('Twitter client').as_null_object
```

#### receive_message_chain 2つモックにする必要のある処理をまとめてモックにする
receive_message_chain メソッドを使うと、2つの処理をモック化できる（業務では124件ヒット）　　
リターンするものがモックになっている場合は、receive_message_chainのお出まし。
```
allow(twitter_client_mock).to receive(:search).and_return([status_mock]) のように、モックがモックを返す時に、使える
```
**注意**  
receive_message_chain を使っているということは、「デメテルの法則」（結合度が高い）に違反したクラス設計になっている可能性がある

##### 例1 「検索実行」と「本文の返却」という2つの処理をモック化すると、
```
allow(weather_bot).to receive_message_chain('twitter_client.search.first.text').and_return('西脇市の天気は曇りです')
```

##### 例2 「インスタンスを作る」と「flagを作成する」の処理をモック化すると、
```
allow(FeatureFlags).to receive_message_chain(:create_instance, :get_flag).with(引数).and_return(Flag.new(引数, true, { "company_ids" => [company.id] }))
```    

##### 例3 「newメソッド」と「getCountメソッド」の処理をモック化すると、
```
describe "作成したクラスで検証" do
  class A
    def doSomething
      b = B.new
      b.getCount()
    end
  end
  
  class B
    def getCount()
      p "実行されちゃったよよよよよよよよよよよよよよよよよよ"
      rand()
    end
  end
  
  context "1.モックを利用しない場合" do
    it "getCountが呼び出される" do
      a = A.new
      expect(a.doSomething()).to eq 0 # これだとgetCount()が呼び出されてしまい、rand()の値が出力される
    end
  end

  context "2.モックを利用した場合" do
    it "getCountが呼び出される" do
      mock_b = double(B)
      allow(B).to receive(:new).and_return(mock_b) # B が newメソッド を受け取ることを許可し、mock_bを返す
      allow(mock_b).to receive(:getCount).and_return(0) # mock_b が getCountメソッド を受け取ることを許可し、0を返す

      a = A.new
      expect(a.doSomething()).to eq 0 # a.doSomething()で、B.newをしているので、b = mock_bとなる。b.getCount()では、b(mock_b).getCount()となり、0を返す。
    end
  end

  context "3.receive_message_chainを利用した場合" do
    it "getCountが呼び出される" do
      allow(B).to receive_message_chain(:new, :getCount).and_return(0) # B.new.getCount をモック化し、0を返すようにする
  
      a = A.new
      expect(a.doSomething()).to eq 0
    end
  end
end
```

### フィーチャスペック編

フィーチャスペック（feature spec）はユーザーの視点からブラウザ上の操作をシミュレートして、実行結果を検証するテスト 
一般的には、「統合テスト」や「エンドツーエンドテスト（E2Eテスト）」と呼ばれている
![image](https://github.com/tomohiko9090/Rspec/assets/66200485/82e37c15-3459-412b-a9df-5db2696b7430)
![image](https://github.com/tomohiko9090/Rspec/assets/66200485/497c5819-4267-4cd6-b6c1-8e17fd0c5d45)


