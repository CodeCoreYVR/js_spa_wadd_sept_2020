// Single Page Application

// When you are using fetch, you are only able to make requests to your sites domains
// unless another site gives your request permission. 
// This is a security implemented in browser and is not applicable anywhere.

// To allow CORS in Rails, you need to do the following:
// 1. Add "rack-cors" gem into your gemfile
// 2. Run bundle to install it
// 3. Create a file called cors.rb inside config/initializers/
// 4. Follow documentation to complete your configuration 
// 5. Edit your cors.rb file to match the one that we have in Awesome Answers API.
// You will see more info inside cors.rb



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

    show(id){
        return fetch(`${BASE_URL}/questions/${id}`)
        .then(res => res.json());
    },

    update(id, params){
        return fetch(`${BASE_URL}/questions/${id}`, {
            method: 'PATCH',
            credentials: 'include',
            headers:{
                "Content-Type": "application/json"
            },
            body: JSON.stringify(params)
        }).then(res => res.json());
    },

    destroy(id){
        return fetch(`${BASE_URL}/questions/${id}`, {
            method: 'DELETE',
            credentials: 'include',
        })
    }

}

// Creating a Session for our user
// Mocking up the login

const Session = {
    create(params){
        return fetch(`${BASE_URL}/session`, {
            method: 'POST',
            credentials: 'include',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(params)
        }).then(res => res.json())
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
            <a class="question-link" data-id="${q.id}" href="">
            ${q.id} - ${q.title}
            </a>
            </li>
            `
        }).join('');
    })
}

loadQuestions();


// Question new
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
        if (data.errors){
            const newQuestionForm = document.querySelector('#new-question-form');
            // remove exiting errors if any
            newQuestionForm.querySelectorAll('p.error-message').forEach(node => {
                node.remove(); // Query for existing p tags within the parent element, if there is, remove it.
            })
            for (const key in data.errors) {
                const errorMessages = data.errors[key].join(', '); // getting all the error messages

                const errorMessageNode = document.createElement('p'); // creating a node
                errorMessageNode.classList.add('error-message');
                errorMessageNode.innerText = errorMessages;

                const input = newQuestionForm.querySelector(`#${key}`); // adding node to DOM

                input.parentNode.insertBefore(errorMessageNode, input);
            }
        } else {
            renderQuestionShow(data.id);
        }
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

// Question show
const questionsContainer = document.querySelector('ul.question-list')
questionsContainer.addEventListener('click', event => {
    event.preventDefault();
    const questionElement = event.target;
    if(questionElement.matches('a.question-link')){
        const questionId = event.target.dataset.id
        renderQuestionShow(questionId);
    }
})

function renderQuestionShow(id) {
    const showPage = document.querySelector('.page#question-show');
    Question.show(id)
    .then(question => {
        const questionHTML = `
        <h2>${question.title}</h2>
        <p>${question.body}</p>
        <small>Authored by: ${question.author.first_name} ${question.author.last_name}</small>
        <small>Liked by: ${question.like_count}</small><br>
        <a data-target="question-edit" data-id="${question.id}" href="">Edit</a><br>
        <a data-target="delete-question" data-id="${question.id}" href="">Delete</a><br>
        `
        showPage.innerHTML = questionHTML;
        navigateTo('question-show');
    })
    // Send an AJAX request to get one question
    // Create elements on the question show page
    // Navigate to question show page
}

document.querySelector('#question-show').addEventListener('click', (event) => {
    event.preventDefault();
    const questionId = event.target.dataset.id
    const actionNeededToBePerformed = event.target.dataset.target
    if(questionId){
        // console.log(questionId);
        if(actionNeededToBePerformed === 'delete-question'){
            console.log(`Delete: ${questionId}`)
            Question.destroy(questionId).then(question => {
                navigateTo('question-index');
            })
        } else {
            console.log(`Edit: ${questionId}`)
            populateForm(questionId);
            navigateTo('question-edit');
        }
    }
})

function populateForm(id){
    Question.show(id).then(questionData => {
        // console.log(questionData)
        document.querySelector('#edit-question-form [name=title]').value=questionData.title;
        document.querySelector('#edit-question-form [name=body]').value=questionData.body;
        document.querySelector('#edit-question-form [name=id]').value=questionData.id;
    })
}

const editQuestionForm = document.querySelector('#edit-question-form'); // Selecting a form from this querySelector
editQuestionForm.addEventListener('submit', (event) => { // Attaching a submit event with this form
    event.preventDefault();
    const editFormData = new FormData(event.currentTarget); // Grabbing data from the form using FormData
    const updatedQuestionParams = { // Creating object of edited data
        title: editFormData.get('title'),
        body: editFormData.get('body')
    }
    // console.log(updatedQuestionParams);
    Question.update(editFormData.get('id'), updatedQuestionParams)
    .then(question => {
        editQuestionForm.reset();
        renderQuestionShow(question.id);
    })
})
