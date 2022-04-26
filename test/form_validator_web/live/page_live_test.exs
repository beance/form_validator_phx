defmodule FormValidatorWeb.PageLiveTest do
  use FormValidatorWeb.ConnCase
  import Phoenix.LiveViewTest

  @create_attrs %{
    username: "username",
    email: "test@test.com",
    password: "password1"
  }

  @invalid_attrs %{
    username: nil,
    email: nil,
    password: nil
  }

  test "renders from title", %{conn: conn} do
    {:ok, _page_live, html} = live(conn, "/")
    assert html =~ "Create Account"
  end

  test "save new account", %{conn: conn} do
    {:ok, page_live, _html} = live(conn, "/")

    assert page_live
           |> form("#user-form", user: @invalid_attrs)
           |> render_change() =~ "can&#39;t be blank"

    {:ok, _, html} =
      page_live
      |> form("#user-form", user: @create_attrs)
      |> render_submit()
      |> follow_redirect(conn, "/")

    assert html =~ "Account created successfully"
  end

  test "validates email", %{conn: conn} do
    invalid_email = %{email: "email"}
    {:ok, page_live, _html} = live(conn, "/")

    assert page_live
           |> form("#user-form", user: invalid_email)
           |> render_change() =~ "must have the @ sign and no spaces"
  end

  test "validates username", %{conn: conn} do
    {:ok, page_live, _html} = live(conn, "/")

    assert page_live
           |> form("#user-form", user: %{username: "a"})
           |> render_change() =~ "should be at least 5 character(s)"

    assert page_live
           |> form("#user-form", user: %{username: "user$"})
           |> render_change() =~
             "Please use letters and numbers without space(only characters allowed _ . -)"
  end

  test "validates password", %{conn: conn} do
    {:ok, page_live, _html} = live(conn, "/")

    assert page_live
           |> form("#user-form", user: %{password: "a"})
           |> render_change() =~ "should be at least 6 character(s)"

    assert page_live
           |> form("#user-form", user: %{password: "."})
           |> render_change() =~
             "at least one lower case character"

    assert page_live
           |> form("#user-form", user: %{password: "."})
           |> render_change() =~
             "at least one upper case character"

    assert page_live
           |> form("#user-form", user: %{password: "."})
           |> render_change() =~
             "at least one digit or punctuation character"
  end
end
