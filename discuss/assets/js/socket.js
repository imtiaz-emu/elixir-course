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

  channel.on(`comments:${topicId}:new`, payload => {
    renderComment(payload.comment);
  });

  document.querySelector('.btn.comment').addEventListener('click', function () {
    let message = document.querySelector('textarea').value;
    channel.push('comment:add', {message: message});
  })
};

function renderComments(comments){
  const renderedComments = comments.map(comment => {
    return commentBlock(comment);
  });

  document.querySelector('.all-comments').innerHTML = renderedComments.join('');
}

function renderComment(comment){
  document.querySelector('.all-comments').innerHTML += commentBlock(comment);
}

function commentBlock(comment){
  return `
      <li class="collection-item">
        ${comment.content}
      </li>
    `
}

window.createSocket = createSocket;
