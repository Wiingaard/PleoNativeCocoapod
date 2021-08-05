/**
 * @format
 */

import {AppRegistry} from 'react-native';
import App from './App';
import {name as appName} from './app.json';
import DummyView from './DummyView'

AppRegistry.registerComponent(appName, () => DummyView);

AppRegistry.registerComponent("DummyView", () => DummyView);
