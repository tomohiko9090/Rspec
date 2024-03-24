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

  describe "3. aroundの検証（beforeとafterの外でaroundを実行）" do
    around(:example) do |example|
      puts "aroundの前半"
      # before
      example.run
      # after
      puts "aroundの後半"
    end

    before(:example) do
      puts "before句を実行"
    end

    after(:example) do
      puts "after句を実行"
    end

    it "テスト①が実行されること" do
      puts "---it句①発動!---"
    end

    it "テスト②が実行されること" do
      puts "---it句②発動!---"
    end
  end

  describe "4. aroundの検証（beforeとafterの中でaroundを実行）→ aroundが直前" do
    around(:example) do |example|
      puts "aroundの前半"

      example.run

      puts "aroundの後半"
    end

    before(:context) do
      puts "before句を実行"
    end

    after(:context) do
      puts "after句を実行"
    end

    it "テスト①が実行されること" do
      puts "---it句①発動!---"
    end

    it "テスト②が実行されること" do
      puts "---it句②発動!---"
    end
  end

  describe "5. aroundの検証（beforeとafterの引数に何も渡さない場合）" do
    around(:example) do |example|
      puts "aroundの前半"

      example.run

      puts "aroundの後半"
    end

    before do
      puts "before句を実行"
    end

    after do
      puts "after句を実行"
    end

    it "テスト①が実行されること" do
      puts "---it句①発動!---"
    end

    it "テスト②が実行されること" do
      puts "---it句②発動!---"
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
          binding.pry
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

  describe 'その3についての検証' do
    describe "ツイートの例を検証" do
      it 'エラーなく予報をツイートすること（ツイートのテスト）' do
        class WeatherBot
          def tweet_forecast
            twitter_client.update '今日は晴れです'
          end

          def twitter_client
            Twitter::REST::Client.new
            p "ツイートしちゃったけど、大丈夫そう？"
          end
        end

        # Twitter clientのモックを作り、updateメソッドが呼びだせるようにする
        twitter_client_mock = double('Twitter client')

        expect(twitter_client_mock).to receive(:update) # updateメソッドが呼び出されないと、エラーになる
        # allow(twitter_client_mock).to receive(:update) # 呼び出されようと、呼び出されまいと知らんぷり

        # twitter_clientメソッドが呼ばれたら、モックを返すように実装を書き換える
        weather_bot = WeatherBot.new
        allow(weather_bot).to receive(:twitter_client).and_return(twitter_client_mock)

        # エラーにならないことを検証
        expect{ weather_bot.tweet_forecast }.not_to raise_error
      end

      it 'エラーが起きたら通知すること（エラーのテスト）' do
        class WeatherBot
          def tweet_forecast
            p "ああああ"
            twitter_client.update '今日は晴れです'
          rescue => e
            notify(e)
          end

          def twitter_client
            p "いいいい"
            Twitter::REST::Client.new
          end

          def notify(error)
            p "うううう"
            # （エラーの通知を行う。実装は省略）
          end
        end

        twitter_client_mock = double('Twitter client')
        allow(twitter_client_mock).to receive(:update).and_raise('エラーが発生しました') # updateメソッドが呼ばれたらエラーを発生させる

        weather_bot = WeatherBot.new
        allow(weather_bot).to receive(:twitter_client).and_return(twitter_client_mock)

        # notifyメソッドが呼ばれることを検証する（allowではなく、expectだから、notifyが呼ばれなかったらエラーになる）
        expect(weather_bot).to receive(:notify)

        weather_bot.tweet_forecast # weather_botのnotifyメソッドが呼び出されたらテストはパスする
      end
    end

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

      context "モックを利用しない場合" do
        it "getCountが呼び出される" do
          a = A.new
          expect(a.doSomething()).to eq 0 # これだとgetCount()が呼び出されてしまい、rand()の値が出力される
        end
      end

      context "モックを利用した場合" do
        it "getCountが呼び出される" do
          mock_b = double(B)
          allow(B).to receive(:new).and_return(mock_b) # B が newメソッド を受け取ることを許可し、mock_bを返す
          allow(mock_b).to receive(:getCount).and_return(0) # mock_b が getCountメソッド を受け取ることを許可し、0を返す

          a = A.new
          expect(a.doSomething()).to eq 0 # a.doSomething()で、B.newをしているので、b = mock_bとなる。b.getCount()では、b(mock_b).getCount()となり、0を返す。
        end
      end

      context "receive_message_chainを利用した場合" do
        it "getCountが呼び出される" do
          allow(B).to receive_message_chain(:new, :getCount).and_return(0) # B.new.getCount をモック化し、0を返すようにする

          a = A.new
          expect(a.doSomething()).to eq 0
        end
      end
    end
  end

  describe "ただの足し算でモックをつくって検証" do
    class Calculator
      def add(a, b)
        a + b
      end
    end

    describe '#add' do
      it '3 + 5 = 8 であること（通常盤）' do
        calculator = Calculator.new
        expect(calculator.add(3, 5)).to eq(8)
      end

      it '3 + 5 = 8 であること（モック盤）' do
        calculator = Calculator.new
        allow(calculator).to receive(:add).and_return(8)
        expect(calculator.add(30000, 50000)).to eq(8) # addの挙動がめっちゃ嘘だけどテストがパスする

        expect(calculator).to have_received(:add).with(30000, 50000) # モックが呼び出されたかどうかを確認
      end
    end
  end

  describe "ダブルでモック作って検証kensyou" do
    class SampleClass
      def self.create_instance
        new
      end

      def get_flag
        "ソリューション部"
      end
    end

    it "" do
      # SampleClass に create_instance メソッドが来たら
      allow(SampleClass).to receive(:create_instance).and_return(double(get_flag: "営業部"))

      instance = SampleClass.create_instance
      expect(instance.get_flag).to eq("営業部") # get_flagの挙動がめっちゃ嘘だけどテストがパスする
    end
  end
end
