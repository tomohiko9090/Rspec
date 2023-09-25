# Rspec
- テストコードは「DRYさ」よりも「読みやすさ」！
- 中身のないitを書いて、テストはあとで書こう

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
#### テストの構造を決める系
- describe 〜の検証
- context 〜の場合
  - なるべく並列の条件を並べる。並列にできない条件が出てきた際に、describeを使って名前空間を作る。
  - 分岐がなければ、1つ。分岐が1つあれば2つのイメージで作成する
- it 〜こと（このブロックで定義されたテスト内容をexampleと呼んだりする）  
  - 中身の無い it。doのブロックなしにすると、Pendingになる。
  - example と specifyは、it のエイリアス。自然な英文を作るためなので、日本語なら使わなくて良さそう。
  - let(:foo) { ... } のように書くと、 { ... } の中の値が foo として参照できるが、ハッシュを定義すると、let(:params) { { name: 'たろう' } }　みたいになるからわかり辛い

#### 先に定義しちゃう系
- before そのブロックで使いたい定義
- let 遅延評価の特徴があることから、expectで出てくる定義を上に上に読んでいける
- let!は、事前に実行されるため、レコードがデータベースに保存されていないからエラーが起きるみたいなことが発生しない
- subject テストするオブジェクトやメソッドが決まっているとき、あらかじめ定義する。is_expectedを使うと、subjectが実行されたとして、テスト実施される
  - 業務では、subjectをメソッドや変数のように使い回さず、is_expectedを使うようにする

#### あんま使わないけど覚えてはおこう系
- shared_examples、it_behaves_likeは、itでテストする内容を再利用できるもの。**定義元だどる必要があるので、業務では禁止**
- shared_context と include_contextは、context内のbeforeやletで定義を再利用して使える。shared_contextで定義して、include_contextで使う。include_contextは、context内のbeforeやletで定義を再利用して使える。shared_contextで定義して、include_contextの""の内容が一緒だと呼び出される。**定義元だどる必要があるので、業務では禁止**
- pending（保留） は、実行を中断するのではなく、そのまま実行を続けることができる　← あんま使わん
- skipは、それ以降実行を止めることができる　　← あんま使わん
- xitは、ブロック丸ごと実行しない
- xdescribe / xcontextは、グループ全体をまとめてskipさせる
- described_class 今テストしているクラスをインスタンス化させるときに使うメソッド。**業務では読みにくくなるので禁止**

#### 綺麗な書き方系
- expextは、期待する結果を変数にせず、なるべくベタ書きで。
