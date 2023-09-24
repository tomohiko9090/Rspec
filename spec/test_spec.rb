# このファイルでは、複数のrubyファイルを実行している。1ファイルで確認したいという意図があるので、ご了承ください。

require 'spec_helper'

require_relative '../lib/test'
require_relative '../lib/user'

RSpec.describe Test do
  describe "1.メッセージが呼び出されるかの検証" do
    it "中身の無い it"

    it "「hello」が呼び出されること" do
      expect(Test.new.message).to eq "hello"

      pending 'pendingこの先はなぜかテストが失敗するのであとで直す'
      # パスしないエクスペクテーション（実行される）
      expect(foo).to eq bar
    end
    it "「hello」が呼び出されること" do
      expect(Test.new.message).to eq "hello"

      skip 'skipとりあえずここで実行を保留'
      # ここから先は実行されない
      expect(foo).to eq bar
    end

    xit '実行したくないテスト' do
      expect(1 + 2).to eq 3
      expect(foo).to eq bar
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


RSpec.describe User do
  describe '3. #greet' do # メソッドのテストは「#」をつける
    let(:user) { User.new(**params) } # **はハッシュオブジェクトをキーワード引数に変換している
    let(:params) { { name: 'たろう', age: age } }

    context '12歳以下の場合' do
      let(:age) { 12 }

      it 'ひらがなで答えること' do 
        expect(user.greet).to eq 'ぼくはたろうだよ。'
      end
    end

    context '13歳以上の場合' do
      let(:age) { 13 }

      it '漢字で答えること' do
        expect(user.greet).to eq '僕はたろうです。'
      end
    end
  end

  describe '4. #greet' do
    let(:user) { User.new(name: 'たろう', age: age) }
    subject { user.greet }

    context '0歳の場合' do
      let(:age) { 0 }
      it { is_expected.to eq 'ぼくはたろうだよ。' } # is_expectedを使えば、subjectが実行できる
    end
    context '12歳の場合' do
      let(:age) { 12 }
      it { is_expected.to eq 'ぼくはたろうだよ。' }
    end

    context '13歳の場合' do
      let(:age) { 13 }
      it { is_expected.to eq '僕はたろうです。' }
    end
    context '100歳の場合' do
      let(:age) { 100 }
      it { is_expected.to eq '僕はたろうです。' }
    end
  end
end



