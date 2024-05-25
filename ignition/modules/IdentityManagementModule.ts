import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const proxyModule = buildModule("ProxyModule", (m) => {
    const proxyAdminOwner = m.getAccount(0);

    const identityManagement = m.contract("IdentityManagement");

    const proxy = m.contract("TransparentUpgradeableProxy", [
        identityManagement,
        proxyAdminOwner,
        "0x"
    ]);

    const proxyAdminAddress = m.readEventArgument(
        proxy,
        "AdminChanged",
        "newAdmin"
    );

    const proxyAdmin = m.contractAt("ProxyAdmin", proxyAdminAddress);

    return { proxyAdmin, proxy };
});

const IdentityManagementModule = buildModule("IdentityManagementModule", (m) => {
    const { proxy, proxyAdmin } = m.useModule(proxyModule);

    const IdentityManagement = m.contractAt("IdentityManagement", proxy);

    return { IdentityManagement, proxy, proxyAdmin };
});

export default IdentityManagementModule;