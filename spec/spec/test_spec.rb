# 実行コマンド
# rspec spec/test_spec.rb

# テスト構造把握コマンド
# rspec spec/test_spec.rb --dry-run --order defined

require 'spec_helper'

require_relative '../lib/test'
require_relative '../lib/user'

RSpec.describe Test do
  describe "1.メッセージが呼び出されるかの検証" do
    it "「hello」が呼び出されること" do
      expect(Test.new.message).to eq "hello"
    end
  end

  describe "2.四則演算の検証" do 
    context "足し算の場合" do
      it '1 + 1 は 2 になること' do
        expect(1 + 1).to eq 2 # 1+1が2と等しくなることを求める
      end
    end

    context "足し算の場合" do
      it '40 / 5は、8 になること' do
        expect(40 / 5).to eq 8
      end
    end
  end
end


RSpec.describe "User" do
  describe "3.Userクラス内のメソッドに関する検証"
    describe '#greet' do # メソッドのテストは「#」をつける
      it '12歳以下の場合、ひらがなで答えること' do
        user = User.new(name: 'たろう', age: 12)
        expect(user.greet).to eq 'ぼくはたろうだよ。'
      end

      it '13歳以上の場合、漢字で答えること' do
        user = User.new(name: 'たろう', age: 13)
        expect(user.greet).to eq '僕はたろうです。'
      end
    end
  end
end
end
