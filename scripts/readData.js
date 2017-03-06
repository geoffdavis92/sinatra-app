// @flow
export default function readData(endpoint:string,callback:Function):Promise {
	return fetch(`http://localhost:4567/data/${endpoint}.json`)
		.then(res => res.json())
		.then(json => JSON.parse(json))
		.then(decodedData => callback(decodedData))
		.catch(e => { throw e })
}