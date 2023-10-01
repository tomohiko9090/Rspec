# このファイルでは、複数のrubyファイルを実行している。1ファイルで確認したいという意図があるので、ご了承ください。

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
  end
end

RSpec.describe User do
  describe "その1についての検証" do
    describe '3. #greet Ver1' do # メソッドのテストは「#」をつける
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

    describe '4. #greet Ver2' do
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

    describe '5. ちょい特殊な検証' do
      it "中身の無い it"
  
      it '1 + 1 は 2 になること' do
        expect(1 + 1).to eq 2 # 1+1が2と等しくなることを求める
  
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
  end

  describe 'その2についての検証' do
    it "1 + 2の結果が正しいこと" do
      expect(1 + 2).to eq 3
      expect(1 + 2).not_to eq 1 # to_notでも良い。
      expect(1 + 2).to be >= 3 # 3より小さいこと。
    end

    it "ちょっと特殊だけど、値が等しいこと" do
      message_1 = 'Hello'
      message_2 = 'Hello'
    
      # expect([message_1].first).to be message # be は等号・不等号なしで書くと、シンボルが同じか判定。A.equal?(B)と同じ。.これは失敗する
      expect([message_1].first).to eq message_2 # これは通る。eqは、同値であれば成功する。
    end

    it "空配列であること" do
      expect([]).to be_empty # この書き方は以下2つと同意
      expect([].empty?).to be true
      expect([].empty?).to eq true
    end

    it "バリデーションに引っかからないこと" do
      # user = User.new(name: 'Tom', email: 'tom@example.com')
      # expect(user).to be_valid # user.valid? が true になればパスする
    end

    it "be真偽値はエラーになること" do
      # どちらもパスする
      expect(1).to be_truthy
      expect(nil).to be_falsey

      # どちらも失敗する
      # expect(1).to be true # 1の値自体が、trueではないからね。
      # expect(nil).to be false

      # be の代わりに eq を使った場合も同様に失敗する
      # expect(1).to eq true
      # expect(nil).to eq false
    end

    it "popメソッドを呼ぶと配列の要素が減少すること" do
      x = [1, 2, 3]
      expect(x.size).to eq 3
      x.pop
      expect(x.size).to eq 2
    end

    it "popメソッドを呼ぶと配列の要素が減少すること（書き換えVer）" do
      x = [1, 2, 3]
      expect{ x.pop }.to change{ x.size }.from(3).to(2) # popするとsizeが3から2に変わるか検証
    end

    it "byを使っても検証できること" do
      x = [1, 2, 3]
      expect{ x.push(4) }.to change{ x.size }.by(1) # 1個増えてるか検証

      y = [1, 2, 3]
      expect{ x.pop }.to change{ x.size }.by(-1) # -1減ったか検証
    end

    it "includeで配列の中に特定の値が入っていること" do
      expect(x).to include 1 # 1が含まれていることを検証する
      expect(x).to include 1, 3 # 1と3が含まれていることを検証する
    end

    it "エラーが起こること" do
      expect{ 1 / 0 }.to raise_error ZeroDivisionError
    end

    it '当選確率が約25%になっていること' do
      class Lottery
        KUJI = %w(あたり はずれ はずれ はずれ)

        def initialize
          @result = KUJI.sample # 無作為に抽出できるメソッド
        end
        def win?
          @result == 'あたり'
        end
        def self.generate_results(count)
          Array.new(count){ self.new }
        end
      end

      results = Lottery.generate_results(10000) # 10000回
      win_count = results.count(&:win?) # win?でtureになった数をカウント
      probability = win_count.to_f / 10000 * 100

      expect(probability).to be_within(1.0).of(25.0) # ゆらぎ1％は許容する
    end
  end
end



