import React from 'react';
import { SplitView } from 'native-navigation';

// import {
//   View,
//   Text,
// } from 'react-native';
//
// const propTypes = {};
// const defaultProps = {};

export default class SplitScreen extends React.Component {
  render() {
    return (
      <SplitView
        master={'ScreenOne'}
        detail={'SharedElementToScreen'}
      />
    );
  }
}
