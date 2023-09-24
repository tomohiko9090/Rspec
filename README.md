# Rspec

## 「実行コマンド」に関するTips
実行コマンド
```
rspec spec/test_spec.rb
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
