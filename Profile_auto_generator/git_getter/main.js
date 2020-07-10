const fetch = require("node-fetch");
const fs = require("fs-extra")
let _remoteAPI = `https://api.github.com/users/${process.env.GITH_USER}/repos?sort=updated&per_page=6&page=1`

async function getRepos(url){
    let _json = await fetch(url);
    let tmp = await _json.json();
    let encoded = tmp.filter((index) => {
      if (index.name !== "Kazanami"){
        return true
      }
    })

    fs.writeFileSync("../repos.json", JSON.stringify(await encoded, null,2 ))
}

getRepos(_remoteAPI)
