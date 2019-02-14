require 'test_helper'
# サイトのレイアウトのリンクに対する統合テスト。
class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path　#root_pathにGETリクエストを送信
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get contact_path
    assert_select "title", full_title("Contact")
  end
end
