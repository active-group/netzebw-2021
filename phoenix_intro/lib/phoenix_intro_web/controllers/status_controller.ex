defmodule PhoenixIntroWeb.StatusController do
  use PhoenixIntroWeb, :controller

  @spec edit(Plug.Conn.t(), any) :: Plug.Conn.t()
  def edit(conn, params) do
    user_id = Map.get(params, "user_id")

    conn
    |> assign(:user_id, user_id)
    |> render("edit.html")
  end


  @spec update(Plug.Conn.t(), any) :: Plug.Conn.t()
  def update(conn, params) do
    status_form = Map.get(params, "status")
    new_status = Map.get(status_form, "new_status")
    user_id =  Map.get(status_form, "user_id")
    PhoenixIntro.UserStatusService.put(user_id, new_status)
    text(conn, "ok")
  end
end
