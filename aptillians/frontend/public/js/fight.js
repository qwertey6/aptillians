document.addEventListener('DOMContentLoaded', () => {
  // We absolutely need the address and aptillian id. Get it from the URL.
  const params = new URLSearchParams(location.search);
  const address = params.get('address');
  const aptillianid = params.get('aptillianid');

  // Hook up the buttons to the FightService.
  const fightService = new FightService();
  const movelist = document.querySelector('.movelist');
  const buttons = movelist.querySelectorAll('button');
  for (let i = 0; i < buttons.length; i++) {
    const button = buttons[i];
    button.addEventListener('click', (e) => {
      const ii = i;
      fightService.makeTurn(ii);
      console.log(`Clicked button ${ii}!`);
    });
  }

  // Poll the server for the current state of the aptillians.
  const aptillianService = new AptillianService();
  setInterval(async () => {
    const aptillian = await aptillianService.getAptillian({
      address: address,
      aptillianId: aptillianid,
    });
    console.log(aptillian);
  }, 5000);
});
