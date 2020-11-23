import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}});

socket.connect();

const createSocket = (topicId) => {
  let channel = socket.channel(`comments:${topicId}`, {});
  channel.join()
    .receive("ok", resp => {
      renderComments(resp.comments);
    })
    .receive("error", resp => { console.log("Unable to join", resp) });

  document.querySelector('.btn.comment').addEventListener('click', function () {
    let message = document.querySelector('textarea').value;
    channel.push('comment:add', {message: message});
  })
};

function renderComments(comments){
  const renderedComments = comments.map(comment => {
    return `
      <li class="collection-item">
        ${comment.content}
      </li>
    `
  });

  document.querySelector('.all-comments').innerHTML = renderedComments.join('');
}

window.createSocket = createSocket;
