
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

### render

[render][React#render] is the most common function to be written on a React Element,
partially because it is a `required` function. A `render()` function
uses `props` and `state` to return a virtual representation of a
node.

In the following case, we ignore `this.props` and `this.state` and
instead render a constant result node representing a paragraph tag
with some text.

```javascript
class SimpleRender extends Component {
  render() {
    return (
      <p>Some Content</p>
    )
  }
}
```

In the following case, we use both `this.props` and `this.state` to
return a more complex element.

```javascript
class ComplexRender extends Component {

  render() {
    const { name } = this.props;
    const { age } = this.state;
    return (
      <div>
        <h3>{name}</h3>
        <p>{name} is {age} years old.</p>
     </div>
    )
  }

}
```

As shown in the code above, the usage of state and props is incredibly
similar. The difference between the two is how (and where) the data is
managed.

### JSX

[JSX][jsx] is an XML-like extension to ECMAScript which is currently a Draft
Speficiation. JSX looks a lot like HTML, but it has some crucial
differences.

For one, JSX transforms to JavaScript. An example of this transform,
given by the React docs is shown below.

```javascript
// Input (JSX)
var app = <Nav color="blue" />;
```

```javascript
// Output (JS):
var app = React.createElement(Nav, {color:"blue"});
```

Our more complex example from before (ComplexRender) transforms into
the following render function when using [babel][babel] for the
transform.

```javascript
function render() {
  var name = this.props.name;
  var age = this.state.age;

  return React.createElement(
    "div",
    null,
    React.createElement(
      "h3",
      null,
      name
      ),
    React.createElement(
      "p",
      null,
      name,
      " is ",
      age,
      " years old."
    )
  );
}
```

Knowing that JSX is transformed into JavaScript enables us to
understand one of the restrictions of our render function: A render
function can only have a single JSX root node as the return
value. This is because of the fact that JSX transforms into JS, which
means returning multiple root nodes would mean the same thing as
writing code that returned multiple functions.

### Dealing with State

When building UI, one of the most complex pieces is the state of the
application. React provides two core ways to manage State,
`this.state` and `this.props`.

As we mentioned before, one of the key differences between
`this.props` and `this.state` is where the data gets
managed. `this.state`, as it turns out, is managed in the same element
it is declared in.

To illustrate the concept of State management in React, we will
revisit the Counter example from earlier in this chapter. In the
following example, we initialize the state of our counter to 0 and
provide two functions to increment and decrement the counter. We also
write a second Element, whose job is to render a number in "human"
form as well as a third element, whose job is to render and dispatch
state changes.

```javascript
import React, { Component, PropTypes } from 'react';
const { number, func } = PropTypes;
import numeral from 'numeral.js';

class HumaneNumber extends Component {

  static propTypes = {
    num: number.isRequired
  }

  humanize(num) {
    return numeral(num).format('0,0');
  }

  render() {
    const { num } = this.props;
    return (
      <span>{this.humanize(num)}</span>
    )
  }
}

export class CounterController extends Component {

  static propTypes = {
    increment: func.isRequired,
    decrement: func.isRequired
  }

  render() {
    const { increment, decrement } = this.props;
    return (
      <section>
        <button onClick={decrement}>-</button>
        <button onClick={increment}>+</button>
      </section>
    );
  }
}

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
        <CounterController increment={this.increment}
                           decrement={this.decrement} />
        <p>Clicked <HumaneNumber number={this.state.count} /> Times</p>
      </div>
    )
  }

}
```

In building this set of elements, we have:

* Pushed event dispatch out to the leaf nodes while maintaining state
  control in a single location (the parent node). This means we only
  have one place to look for all of the possible ways state can be
  altered.
* Encapsulated the display of human-readable numbers into a
  [dumb element][dumb-elements].
* Separated the display of the control panel from the definition of
  state-adjusting logic.
* Clearly defined APIs for our dumb elements.

The parent node is specifying "This is what you can do to the state of
the application" while our child elements are specifying their own API
contract relating to how the user interacts with the UI.

#### Dumb Elements and propTypes

In accordance with @dan_abramov's definition of
[Dumb Elements][dumb-elements]. They are elements which:

* Have no dependencies on the rest of the app, e.g. Flux actions or
  stores.
* Often allow containment via this.props.children.
* Receive data and callbacks exclusively via props.
* Have a CSS file associated with them.
* Rarely have their own state.
* Might use other dumb components.
* Examples: Page, Sidebar, Story, UserInfo, List.

Talking briefly about `HumaneNumber`, we have created an element which
abstracts the choice of "Which format do I use to represent numbers in
my application?".

propTypes define the API supported by a dumb element. For example, by
looking at the following PropTypes, we can determine a fair bit of
information about the element we're using.

```javascript
static propTypes = {
  title: string.isRequired,
  isEligible: bool,
  age: number.isRequired
}
static defaultProps = {
  isEligible: false
}
```

Notice how we're using `defaultProps` to fill in the gaps for those
properties which we don't require to be passed in when using the
element.

#### HumaneNumber and encapsulating third party libraries

`HumaneNumber` is nice because it provides an opinionated way to
display numbers in an application, but we could use it to greater
effect if we encapsulated [Numeral.js][numeral.js] in it's own
element. (note that we've skipped some of the Numeral API and focused
solely on rendering formatted strings).

```javascript
// HumaneNumber.js
import React, { Component, PropTypes } from 'react';
const { number, oneOf } = PropTypes;
import numeral from 'numeral.js';

export class Numeral extends Component {

  static propTypes = {
    format: string,
    num: number.isRequired
  }

  static defaultProps = {
    format: '0,0'
  }

  mkNumeral = () => {
    const { num, format } = this.props;
    return numeral(num).format(format);
  }

  render() {
    return (
      <span>{this.mkNumeral()}</span>
    )
  }
}

export default class HumaneNumber extends Component {

  static propTypes = {
    num: number.isRequired
  }

  render() {
    const { num } = this.props;
    return (
      <Numeral num={num} format='0,0' />
    )
  }
}
```

We can now import and use the simplified `HumaneNumber` or the more 
powerful `Numeral` element in another place in our application.

```javascript
import React, { Component, PropTypes } from 'react';
const { number } = PropTypes;
import HumaneNumber, { Numeral } from './HumaneNumber';

class TimeAndMoney extends Component {

  static propTypes = {
    days: number.isRequired,
    money: number.isRequired
  }

  render() {
    return (
      <div>
        <p>In <HumaneNumber num={days} /> days; you've made
        <Numeral num={money} format='($ 0.00 a)' /> dollars</p>
      </div>
    )
  }
}
```
