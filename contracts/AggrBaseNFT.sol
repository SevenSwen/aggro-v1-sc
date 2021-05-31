// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC721Metadata, IERC721, IERC165} from '@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol';
import {IERC721Receiver} from '@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol';
import {Address} from '@openzeppelin/contracts/utils/Address.sol';
import {Context} from '@openzeppelin/contracts/utils/Context.sol';
import {Strings} from '@openzeppelin/contracts/utils/Strings.sol';
import {ERC165} from '@openzeppelin/contracts/utils/introspection/ERC165.sol';

import {AggrOwnable} from './AggrOwnable.sol';

contract AggrBaseNFT is Context, ERC165, IERC721, IERC721Metadata, AggrOwnable {
    using Address for address;
    using Strings for uint256;

    // Token name
    string override public name = 'AggrNFT';

    // Token symbol
    string override public symbol = 'AGGR';

    // Token URL
    string public baseURI;

    // Mapping from token ID to token creator address
    mapping (uint256 => address) private _rednecks;

    // Mapping from token ID to victim address
    mapping (uint256 => address) private _victims;

    // Mapping victim address to token count
    mapping (address => uint256) private _swearWords;

    // Mapping from token ID to approved address
    mapping (uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) private _operatorApprovals;

    modifier Exists(uint256 tokenId) {
        require(_rednecks[tokenId] != address(0), 'A: fuck');
        _;
    }

    // OnlyAggrOwner functions
    function setBaseURI(string memory _baseURI) external OnlyAggrOwner {
        baseURI = _baseURI;
    }

    // Other functions

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
        return interfaceId == type(IERC721).interfaceId
        || interfaceId == type(IERC721Metadata).interfaceId
        || super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address victim) external view override returns (uint256) {
        require(victim != address(0), 'A: goof not found');
        return _swearWords[victim];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) external view override returns (address) {
        address victim = _victims[tokenId];
        require(victim != address(0), 'A: fuck off');
        return victim;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) external view Exists(tokenId) override returns (string memory) {
        string memory _baseURI = baseURI;
        return bytes(_baseURI).length > 0
            ? string(abi.encodePacked(_baseURI, tokenId.toString()))
            : '';
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) external override {
        address redneck = _rednecks[tokenId];
        require(to != redneck, 'A: what the fuck?');

        require(_msgSender() == redneck || isApprovedForAll(redneck, _msgSender()),
            'A: you shall not pass (A)'
        );

        _approve(redneck, to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId) external view Exists(tokenId) override returns (address) {
        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address looser, bool approved) external override {
        address bossOfThisGum = _msgSender();
        require(looser != bossOfThisGum, 'A: idiot');

        _operatorApprovals[bossOfThisGum][looser] = approved;
        emit ApprovalForAll(bossOfThisGum, looser, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address bossOfThisGum, address looser) public view override returns (bool) {
        return _operatorApprovals[bossOfThisGum][looser];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(address from, address to, uint256 tokenId) external override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), 'A: you shall not pass (TF)');

        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external override {
        safeTransferFrom(from, to, tokenId, '');
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), 'A: you shall not pass (STF)');
        _safeTransfer(from, to, tokenId, _data);
    }

    // internal functions
    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), 'A: send to fucking contract');
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view Exists(tokenId) returns (bool) {
        address redneck = _rednecks[tokenId];
        return (spender == redneck || _tokenApprovals[tokenId] == spender || isApprovedForAll(redneck, spender));
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), 'A: you are stupid');
        require(_rednecks[tokenId] == address(0), 'A: you are slowpoke');

        _rednecks[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual {
        address redneck = _rednecks[tokenId];
        address victim = _victims[tokenId];

        // Clear approvals
        _approve(redneck, address(0), tokenId);

        _swearWords[victim] -= 1;
        delete _rednecks[tokenId];
        delete _victims[tokenId];

        emit Transfer(victim, address(0), tokenId);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        address redneck = _rednecks[tokenId];
        address victim = _victims[tokenId];
        require(redneck == from, 'A: deceiver');
        require(victim == address(0), 'A: swearing already used');
        require(to != address(0), 'A: send to hell');

        // Clear approvals from the previous owner
        _approve(redneck, address(0), tokenId);

        _swearWords[victim] += 1;
        _victims[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits a {Approval} event.
     */
    function _approve(address from, address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(from, to, tokenId);
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
    private returns (bool)
    {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver(to).onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert('ERC721: transfer to non ERC721Receiver implementer');
                } else {
                    // solhint-disable-next-line no-inline-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }
}
