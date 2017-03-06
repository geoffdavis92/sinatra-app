// @flow
import React, { Component } from 'react'
import { render } from 'react-dom'

import readData from './readData'
import { curry } from './utilities'

let x = curry(1)(2)

console.log(x)

readData('authors', (data) => console.log(data))


class App extends Component {
	constructor(props) {
		super(props);
		this.state = {}
		this.componentDidMount = this.componentDidMount.bind(this)
	}
	componentDidMount() {
		readData('authors', data => {
			this.setState({ authors: data })		
		})
	}
	render() {
		if (this.state.authors) {
			const authors = this.state.authors.map( author => <p><a href={`/author/${author.fullname.toLowerCase().replace(/\s/,'-')}`}>{author.fullname}</a></p>)
			return <div>{authors}</div>
		} else {
			return (
				<p>LOADING...</p>
			)
		}
	}
}

render(<App/>,document.getElementById('app'))