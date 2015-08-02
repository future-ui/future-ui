
# Rendering

In this book, we will be focusing on React for controlling the
rendering of our applications. According to the React site, React is:

> A JAVASCRIPT LIBRARY FOR BUILDING USER INTERFACES

Notice that there is no mention of the DOM because React is not tied
to a specific render target. In practice, this means we can render to
DOM, SVG, Canvas and even native iOS components. Most importantly,
React is a component model for abstractions.

## Virtual DOM

The abstraction used which allows us to render to multiple targets is
referred to as the Virtual DOM. Simply speaking, the Virtual DOM is a tree
structure which allows us to diff against previous versions of our
rendered application.

In practice one of the benefits is that we have to worry less about
DOM insertion optimizations such as batching updates. A spec-compliant
synthetic event system means that bubbling and capturing works the
same across browsers.

The React docs explain the implications well:

> Event delegation: React doesn't actually attach event handlers to
> the nodes themselves. When React starts up, it starts listening for
> all events at the top level using a single event listener. When a
> component is mounted or unmounted, the event handlers are simply
> added or removed from an internal mapping. When an event occurs,
> React knows how to dispatch it using this mapping. When there are no
> event handlers left in the mapping, React's event handlers are
> simple no-ops. To learn more about why this is fast, see [David
> Walsh's excellent blog post](http://davidwalsh.name/event-delegate).


## Basics

### A Simple Component

The following component renders a heading. We can then use
`React.render` to attach to the body of the document.

```javascript
import React, { Component } from 'react';

export default class Simple extends Component {
  render() {
    return <p>Hello World</p>;
  }
}
```

```javascript
React.render(<Simple/>, document.body);
```

To see this component in action, run the following:

```bash
git clone git@github.com:future-ui/basics.git
cd basics && npm install
npm start
```

then go to `localhost:3000`

The example is hot-reloadable, which means that you can edit the
`src/App.js` file and see the changes in the browser immediately. You
should play around a bit and see what happens.

### A More Complex Example

We want to display a counter which we can adjust using various
buttons.

```javascript
import React, { Component } from 'react';

export default class Counter extends Component {

  state = {
    count: 0
  }

  increment = (e) => {
    const { count } = this.state;
    this.setState({
      count: count + 1
    });
  }

  decrement = (e) => {
    const { count } = this.state;
    this.setState({
      count: count - 1
    });
  }

  render() {
    return (
      <div>
        {this.renderControls()}
        <section>
          <h1>My Awesome Counter!</h1>
          <p>Counters are an integral part of counting things!</p>
        </section>
      </div>
    )
  }

  renderControls = () => {
    const { count } = this.state;
    return (
      <section>
        <button onClick={this.decrement}>-</button>
        <span>{count}</span>
        <button onClick={this.increment}>+</button>
      </section>
    );
  }
}
```

If you take the above example and paste it in to the App.js file from
before, you will see it render roughly as:

```html
<div data-reactid=".0">
  <section data-reactid=".0.0">
    <button data-reactid=".0.0.0">-</button><span data-reactid=
    ".0.0.1">7</span><button data-reactid=".0.0.2">+</button>
  </section>

  <section data-reactid=".0.1">
    <h1 data-reactid=".0.1.0">My Awesome Counter!</h1>

    <p data-reactid=".0.1.1">Counters are an integral part of counting
    things!</p>
  </section>
</div>
```

Each of the `data-reactid`s is a node in the tree.
