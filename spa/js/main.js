const BASE_URL = `http://localhost:3000/api/v1`

const Question = {
    index(){
        return fetch(`${BASE_URL}/questions`)
        .then(res => {
            // res object has a method '.json' that will parse the body of response and return it as json format.
            console.log(res);
            return res.json();
        })
    },
}

Question.index()
    .then(questions => {
        const questionsContainer = document.querySelector('ul.question-list');
        questionsContainer.innerHTML = questions.map(q => {
            return `
            <li>
            ${q.id} - ${q.title}
            </li>
            `
        }).join('');
    })


