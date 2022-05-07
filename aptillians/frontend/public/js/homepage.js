document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('form');
    function logSubmit(event) {
        event.preventDefault();
        const input = form.querySelector('input');
        location.href = './statspage.html?address=' + input.value; 
    }
    form.addEventListener('submit', logSubmit);
});