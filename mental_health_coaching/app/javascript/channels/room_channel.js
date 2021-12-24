import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const room_element = document.getElementById('room-id');
  const room_id = room_element.getAttribute('data-room-id');

  console.log(consumer.subscriptions.subscriptions)
  consumer.subscriptions.subscriptions.forEach((subscription) => {
   consumer.subscriptions.remove(subscription)
  })

  consumer.subscriptions.create({ channel: "RoomChannel", room_id: room_id } , {
    connected() {
      console.log("Connected to ..." + room_id)
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      console.log(data)
      let messagesContainer = document.getElementById('messages')
      messagesContainer.innerHTML = messagesContainer.innerHTML + data.html
      // window.location.reload();
      // Called when there's incoming data on the websocket for this channel
    }
  });
})
