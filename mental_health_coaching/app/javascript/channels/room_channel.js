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
      let messagesCoachContainer = document.getElementById('messages_coach')
      let messagesUserContainer = document.getElementById('messages_user')
      messagesCoachContainer.innerHTML = messagesCoachContainer.innerHTML + data.coach
      messagesUserContainer.innerHTML = messagesUserContainer.innerHTML + data.user
      // Called when there's incoming data on the websocket for this channel
    }
  });
})
