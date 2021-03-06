require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
              password: "foobar", password_confirmation: "foobar"))
  end
  #有効かどうか確認
  test "should be valid" do
    assert @user.valid?
  end


  # model バリデーションに対するテスト
  #名前があるか確認
  test "name should be present" do
    # @user.nameを空で保存
    @user.name = "     "　　
    #有効でないことを確認
    assert_not @user.valid?
  end

  # emailがあるか確認
 test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  # 名前の長さのテスト
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  # emailの長さのテスト
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  # 有効なメールフォーマットをテストする

  # emailの検証は有効なアドレスであるべき
  test "email validation should accept valid addresses" do

    # 有効なアドレス(複数)を、配列にして代入
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]


    # eachループ(eachメソッドを使って各メールアドレスを順にテスト)
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      # assert(式 [, メッセージ])	式が真ならば成功
      # @userが有効なら、メッセージを表示
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end

  end

  # emailの検証は無効なアドレスであるべき
  test "email validation should be invalid addresses" do

    # 無効なアドレス(複数)を、配列にして代入
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      # @userが無効なら、メッセージを表示
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  # 重複するメールアドレス拒否のテスト
 test "email addresses should be unique" do
   # ユーザーの複製。オブジェクトのコピー .dup
   duplicate_user = @user.dup
   # 大文字・少文字を区別しない、一意性のテスト
   duplicate_user.email = @user.email.upcase # .upcase 大文字に変換
   # 複製したユーザーを保存
   @user.save
   # 有効で無いことを確認
   assert_not duplicate_user.valid?
 end

 # メールアドレスの少文字化に対するテスト
 # メールアドレスは小文字で保存する必要があります
 test "email addresses should be saved as lower-case" do
    # 大文字・少文字の混ざったメールアドレスを代入
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    # mixed_case_email.downcaseと、@user.reload.emailが等しいかチェック
    # .reload データベースの値に合わせて更新する
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  
  test "password should be present (nonblank)" do
   @user.password = @user.password_confirmation = " " * 6
   assert_not @user.valid?
 end

 test "password should have a minimum length" do
   @user.password = @user.password_confirmation = "a" * 5
   assert_not @user.valid?
 end
end
