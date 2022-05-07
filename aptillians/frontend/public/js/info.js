document.addEventListener('DOMContentLoaded', () => {
    const button = document.getElementById('send-button');
    function logSubmit(event) {
        location.href = './fight.html?address=TODO&aptillianid=TODO'
    }
    button.addEventListener('click', logSubmit);

});
