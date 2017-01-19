# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Batch do
  let(:subject) { Rouge::Lexers::Batch.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.bat'
      assert_guess :filename => 'FOO.BAT'
      assert_guess :filename => 'foo.cmd'
      assert_guess :filename => 'FOO.CMD'
    end
  end
end
