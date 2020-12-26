//
//  StartupCommandsBuilder.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//

import Foundation
// MARK: - Builder
final class StartupCommandsBuilder {

    func build() -> [Command] {
        return [
            InitializeThirdPartiesCommand(),
            AuthManagerCommand(),
            InitializeAppearanceCommand(),
            RegisterToRemoteNotificationsCommand(),
            StartupConfigs()
        ]
    }
}
