defmodule LiveViewEventPassingDemoWeb.Live.Widgets.WidgetCircle do
  use LiveViewEventPassingDemoWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    sess = session["live_view_broadcaster_session"]
    {:ok, broadcast_group} = LiveViewEventPassingDemo.OTP.LiveViewDispatcher.subscribe(sess)
    LiveViewEventPassingDemo.OTP.LiveViewDispatcher.subscribe({broadcast_group, :widget_c})
    {:ok,
      socket
      |> assign(broadcast_group: broadcast_group)
    }
  end

  @impl true
  def handle_event("broadcast", _, socket) do
    LiveViewEventPassingDemo.OTP.LiveViewDispatcher.publish(socket.assigns[:broadcast_group], :hello_everyone)
    {:noreply, socket}
  end


  def handle_info(event, socket) do
    socket = socket
             |> assign(last_event: event)
    {:noreply, socket}
  end

end
