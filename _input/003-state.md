
# State Management and Abstraction

When building UI, one of the most complex pieces is the state of the
application. React provides two core ways to manage State,
`this.state` and `this.props`. We will also talk about a third way to
manage state: Redux. It turns out that the way elements abstract
functionality has a large implication for how state is managed.

As we mentioned before, one of the key differences between
`this.props` and `this.state` is where the data gets
managed. `this.props` gets passed in to an element from
"outside". This means that props aren't controlled by the element
displaying them.

## Dumb Elements and propTypes

To see why the concept of props is so useful, we are going to explore
the concept of [Dumb Elements][dumb-elements]. In accordance with
@dan_abramov's definition of [Dumb Elements][dumb-elements]. They are
elements which:

* Have no dependencies on the rest of the app, e.g. Flux actions or
  stores.
* Often allow containment via this.props.children.
* Receive data and callbacks exclusively via props.
* Have a CSS file associated with them.
* Rarely have their own state.
* Might use other dumb components.
* Examples: Page, Sidebar, Story, UserInfo, List.

Talking briefly about our `HumaneNumber` example, we have created an
element which abstracts the choice of "Which format do I use to
represent numbers in my application?". This has a number of benefits
including reducing the opportunity to use the wrong format and
reducing the mental burden of writing the UI. Reducing mental burdens,
even in this simple way, is critically important to opening up
opportunity to focus on business logic.

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

The above element takes three possible attributes. `title` is a
`string`, and we have no good default value for a `title` so it's
required. We also have an `age` attribute, which is a required
`number`, and an `isEligible` attribute, which is an option
`boolean`. Notice how we're using `defaultProps` to fill in the gaps
for those properties which we don't require to be passed in when using
the element. `defaultProps` are a great way to reduce the noise on the
consumer's side when defining an element's API.

#### Using PropTypes to encapsulate third party libraries

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

If we rendered money in enough places in our application, it might
also make sense to build a `<Currency currency='usd'/>` element to
display different countries' currency. For now, the raw ability of the
`<Numerical/>` element serves any additional number-rendering need
that may crop up in our application.

Notice that the `<Numeral/>` element will behave exactly the same as
the `<HumaneNumber/>` element if you leave out the `format` because
the default format for `<Numeral/>` is the same. This brings up an
interesting design decision when building dumb elements. How much of
the API should you expose?

`<HumaneNumber/>` has a much more restrictive API. The benefits of
this include always knowing how a `<HumaneNumber/>` will treat a `num`
attribute and a smaller API surface area.

`<Numeral/>` provides more power, but has a larger API surface area
and is easily modified to show numbers differently.

Often, I'll opt for a more opinionated API such as `<HumaneNumber/>`
because it clearly expresses the intent I had when I built the
UI. There are no questions about whether I forgot a comma, etc in the
formatting string because of the restrictive API. More powerful APIs
such as `<Numeral/>` are *always* nice to have in case an unexpected
situation arises. One can even build more opinionated elements from
the more powerful elements. The API can be optionally restricted for
each additional element while the more powerful or harder-to-use API
is hidden for advanced users.

### PropTypes

It is a good idea to declare `propTypes` for every element which takes
props. There are a number of benefits to doing this including
documentation and the fact that if you specify the types correctly,
React will warn you of data which is passed in that doesn't match the
expected signature.

One real-world and slightly messy application of propType warnings is
as a canary for changing APIs. If the propTypes match up with the
values that are expected to be received from an API, and that API
changes: The propTypes can serve as a late warning that the data is
not in the structure the application expects.

## Smart Elements

### State

## Redux
