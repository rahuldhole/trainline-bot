if (window.performance) {
  var resourceEntries = window.performance.getEntriesByType('resource');
  var apiUrls = resourceEntries
    .filter(entry => entry.initiatorType === 'xmlhttprequest')
    .map(entry => entry.name);

  let match_url = 'https://geo.captcha-delivery.com/captcha/check'
  let matching_url = apiUrls[0].match(match_url);
  if (matching_url) {
    fetch(apiUrls[0])
      .then(response => response.json())
      .then(data => console.log(data['cookie']))
      .catch(error => console.error(error));
  }
  else {
    console.error('No cookie found');
  }
} else {
  console.error('Performance API not supported');
}