import React from 'react';
import {Text, View} from 'react-native';

const DummyView = () => {
    return <View style={{backgroundColor: 'blue', flex: 1, justifyContent: 'center', alignItems: 'center'}}>
        <Text style={{color: 'white'}}>Hello from React Native</Text>
    </View>
}

export default DummyView;
