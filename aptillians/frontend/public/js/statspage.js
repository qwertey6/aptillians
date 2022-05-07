document.addEventListener('DOMContentLoaded', () => {
    const button = document.getElementById('send-button');
    function logSubmit(event) {
        location.href = './fight.html?address=TODO!!&aptillianidTODO'
    }
    button.addEventListener('click', logSubmit);

});