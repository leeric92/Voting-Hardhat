import "./proposal.css";

export default function build({ question, yesCount, noCount, isClosed, numVotes }, id) {  
  const voteActions = numVotes >= 5 ? '' : `
    <div class="vote-actions">
      <div id="yes-${id}" class="button vote-yes"> Vote Yes </div>
      <div id="no-${id}" class="button vote-no"> Vote No </div>
      <div id="remove-${id}" class="button vote-remove vote-no"> Remove Vote </div>
    </div>
`

  return `
    <div class="proposal">
      <div class="question"> ${question} </div>
      <div class="counts">
        <div class="yes-count"> Yes: ${yesCount} </div>
        <div class="no-count"> No: ${noCount} </div>
      </div>
      ${voteActions}
    </div>
  `;
}
