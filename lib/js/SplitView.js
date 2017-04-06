import React, { PropTypes } from 'react';
import {
  View,
} from 'react-native';
import SafeModule from 'react-native-safe-module';

const NativeSplitView = SafeModule.component({
  viewName: 'NativeNavigationSplitView',
  mockComponent: () => <View />,
});

class SplitView extends React.Component {
  render() {
    const { master, detail } = this.props;
    return (
      <NativeSplitView
        master={master}
        detail={detail}
      />
    );
  }
}

SplitView.propTypes = {
  master: PropTypes.string.isRequired,
  detail: PropTypes.string,
};

module.exports = SplitView;
