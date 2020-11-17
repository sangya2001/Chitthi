import React from 'react'
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';
import Home from './Pages/Home';
import Login from "./Pages/Login"
import ChainContext from "./Contexts/ChainContext"
import Dashboard from "./Pages/Dashboard"

function App() {
  return (
    <Router>
      <Switch>
        <Route exact path="/" component={Home}/>
        <Route exact path="/auth" component={Login}/>
        <Route exact path="/dashboard" render={() => <ChainContext> <Dashboard/> </ChainContext>}/>
      </Switch>
    </Router>
  );
}

export default App;
