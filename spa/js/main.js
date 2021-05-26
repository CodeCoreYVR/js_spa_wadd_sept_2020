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

    create(params){
        return fetch(`${BASE_URL}/questions`, {
           method: 'POST',
           credentials: 'include', 
           headers: {
               'Content-Type': 'application/json'
           },
           body: JSON.stringify(params) 
        }).then((res) => res.json());
    },

}

const Session = {
    create(params){
        return fetch(`${BASE_URL}/session`, {
            method: 'POST',
            credentials: 'include',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(params)
        })
    }
}

Session.create({
    email: 'js@winterfell.gov',
    password: 'supersecret'
}).then(console.log);


function loadQuestions(){
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
}

loadQuestions();

const newQuestionForm = document.querySelector('#new-question-form');    
newQuestionForm.addEventListener('submit', (event) => {
    event.preventDefault();
    const form = event.currentTarget
    const formData = new FormData(form);
    const newQuestionParams = {
        title: formData.get('title'),
        body: formData.get('body')
    }
    Question.create(newQuestionParams)
    .then(data => {
        loadQuestions();
    })
})

function navigateTo(id) { 
    // Navigate remove the active class and re-apply it to a specific node
    // Id will be one of: welcome, question-index, question-new, question-show
    document.querySelectorAll('.page').forEach(node => {
        // Remove the active class from every page node
        node.classList.remove('active');
    });
    document.querySelector(`.page#${id}`).classList.add('active');
}


// Add Navigation
const navbar = document.querySelector('nav.navbar')
navbar.addEventListener('click', (event) => {
    event.preventDefault();
    const node = event.target
    const page = node.dataset.target;
    if(page){
        navigateTo(page);
    }
});



