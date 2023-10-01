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
<br>
「trueっぽい値」または「falseっぽい値」なので、どちらもパスする
```
expect(1).to be_truthy # 判定した結果がtrueだから
expect(nil).to be_falsey
```
<br>
どちらも失敗する
```
expect(1).to be true # 1 = trueではないから失敗
expect(nil).to be false
```
<br>
be の代わりに eq を使った場合も同様に失敗する
```
expect(1).to eq true
expect(nil).to eq false
```
<br>
- change は内容が変更されることを意味する
  - from/to で何から何に変化したのかかく
  - by で変化した数をかく
- include は含まれているか。
```
expect(x).to include 1, 3
```
<br>
- raise_error は、エラーが正しく起こるかどうかを確認するもの。異常系のテストとかで使えそう。
- be_within は、be_within(1.0).of(25.0)で25から±1を許容しているかテストするもの
